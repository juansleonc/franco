import React, { useState } from 'react';
import { View, FlatList, TextInput, StyleSheet, Alert } from 'react-native';
import { Screen, H1, PrimaryButton, Card, Label } from '@/components/ui';
import { apiRequest } from '@/lib/api';
import { useMutation } from '@tanstack/react-query';

type Candidate = { invoice_id: string; tenant_id: string; stage: string; email?: string; phone?: string };

export default function DunningScreen() {
  const [asOf, setAsOf] = useState<string>('');
  const [data, setData] = useState<Candidate[]>([]);

  const previewMut = useMutation({
    mutationFn: async () => (await apiRequest<{ data: Candidate[] }>(`/v1/dunning/preview${asOf ? `?as_of=${asOf}` : ''}`)).data,
    onSuccess: (res) => setData(res),
    onError: (e: any) => Alert.alert('Error', e.message),
  });

  const sendBulkMut = useMutation({
    mutationFn: async () => {
      const invoice_ids = data.map(d => d.invoice_id);
      return apiRequest<{ data: { enqueued: number; throttled: number } }>(`/v1/dunning/send_bulk`, {
        method: 'POST',
        body: { invoice_ids, channels: ['email', 'sms'] },
      });
    },
    onSuccess: (res) => Alert.alert('Enqueued', `enqueued=${res.data.enqueued}, throttled=${res.data.throttled}`),
    onError: (e: any) => Alert.alert('Error', e.message),
  });

  return (
    <Screen>
      <H1>Dunning</H1>
      <Card>
        <Label>As of (YYYY-MM-DD)</Label>
        <TextInput style={styles.input} placeholder="2025-08-20" value={asOf} onChangeText={setAsOf} />
        <PrimaryButton title={previewMut.isPending ? 'Loading...' : 'Preview'} onPress={() => previewMut.mutate()} />
        <PrimaryButton title={sendBulkMut.isPending ? 'Sending...' : 'Send Bulk (email+sms)'} onPress={() => sendBulkMut.mutate()} disabled={data.length === 0} />
      </Card>
      <FlatList
        data={data}
        keyExtractor={(item) => item.invoice_id}
        renderItem={({ item }) => (
          <Card>
            <Label>{item.stage}</Label>
            <Label>{item.email || item.phone}</Label>
          </Card>
        )}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  input: { borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 10, padding: 10, marginBottom: 8, backgroundColor: '#fff' },
});
