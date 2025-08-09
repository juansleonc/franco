import React, { useState } from 'react';
import { View, Button, FlatList, TextInput, StyleSheet, Alert } from 'react-native';
import { Text } from '@/components/Themed';
import { apiRequest } from '@/lib/api';
import { useMutation } from '@tanstack/react-query';

type Candidate = { invoice_id: string; tenant_id: string; stage: string; email?: string; phone?: string };

export default function DunningScreen() {
  const [asOf, setAsOf] = useState<string>('');
  const [data, setData] = useState<Candidate[]>([]);
  const [loading, setLoading] = useState(false);

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
    <View style={styles.container}>
      <Text style={styles.title}>Dunning</Text>
      <TextInput style={styles.input} placeholder="As of (YYYY-MM-DD)" value={asOf} onChangeText={setAsOf} />
      <Button title={previewMut.isPending ? 'Loading...' : 'Preview'} onPress={() => previewMut.mutate()} />
      <Button title={sendBulkMut.isPending ? 'Sending...' : 'Send Bulk (email+sms)'} onPress={() => sendBulkMut.mutate()} disabled={data.length === 0} />
      <FlatList
        data={data}
        keyExtractor={(item) => item.invoice_id}
        renderItem={({ item }) => (
          <View style={styles.row}>
            <Text>{item.invoice_id.slice(0, 6)} • {item.stage} • {item.email || item.phone}</Text>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  title: { fontSize: 20, fontWeight: '600', marginBottom: 12 },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 8, marginBottom: 8 },
  row: { paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#eee' },
});
