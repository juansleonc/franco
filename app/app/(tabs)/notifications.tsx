import React, { useState } from 'react';
import { View, TextInput, FlatList, StyleSheet, Alert } from 'react-native';
import { Screen, H1, PrimaryButton, Card, Label } from '@/components/ui';
import { apiRequest } from '@/lib/api';
import { useMutation, useQuery } from '@tanstack/react-query';

type Log = { id: string; invoice_id: string; tenant_id: string; channel: string; status: string; error?: string; sent_at: string };

export default function NotificationsScreen() {
  const [to, setTo] = useState('test@example.com');
  const [phone, setPhone] = useState('+123456');
  const logsQuery = useQuery({
    queryKey: ['notificationLogs'],
    queryFn: async () => (await apiRequest<{ data: Log[] }>('/v1/notifications/logs?limit=50')).data,
  });
  const sendEmail = useMutation({
    mutationFn: async () => apiRequest('/v1/notifications/send_test', { method: 'POST', body: { to, subject: 'Hi', body: 'Hello' } }),
    onSuccess: () => Alert.alert('Email sent'),
    onError: (e: any) => Alert.alert('Error', e.message),
  });
  const sendSms = useMutation({
    mutationFn: async () => apiRequest('/v1/notifications/send_test_sms', { method: 'POST', body: { to: phone, body: 'Test SMS' } }),
    onSuccess: () => Alert.alert('SMS sent'),
    onError: (e: any) => Alert.alert('Error', e.message),
  });

  return (
    <Screen>
      <H1>Notifications</H1>
      <Card>
        <Label>Test Email</Label>
        <TextInput style={styles.input} value={to} onChangeText={setTo} placeholder="Email" />
        <PrimaryButton title={sendEmail.isPending ? 'Sending...' : 'Send test email'} onPress={() => sendEmail.mutate()} />
      </Card>
      <Card>
        <Label>Test SMS</Label>
        <TextInput style={styles.input} value={phone} onChangeText={setPhone} placeholder="Phone" />
        <PrimaryButton title={sendSms.isPending ? 'Sending...' : 'Send test SMS'} onPress={() => sendSms.mutate()} />
      </Card>
      <PrimaryButton title={logsQuery.isPending ? 'Loading logs...' : 'Refresh logs'} onPress={() => logsQuery.refetch()} />
      <FlatList
        data={logsQuery.data || []}
        keyExtractor={(i) => i.id}
        renderItem={({ item }) => (
          <Card><Label>{new Date(item.sent_at).toLocaleString()}</Label><Label>{item.channel} • {item.status}</Label></Card>
        )}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  input: { borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 10, padding: 10, marginVertical: 8, backgroundColor: '#fff' },
});
