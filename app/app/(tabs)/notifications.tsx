import React, { useState } from 'react';
import { View, Button, TextInput, FlatList, StyleSheet, Alert } from 'react-native';
import { Text } from '@/components/Themed';
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
    <View style={styles.container}>
      <Text style={styles.title}>Notifications</Text>
      <TextInput style={styles.input} value={to} onChangeText={setTo} placeholder="Email" />
      <Button title={sendEmail.isPending ? 'Sending...' : 'Send test email'} onPress={() => sendEmail.mutate()} />
      <TextInput style={styles.input} value={phone} onChangeText={setPhone} placeholder="Phone" />
      <Button title={sendSms.isPending ? 'Sending...' : 'Send test SMS'} onPress={() => sendSms.mutate()} />
      <Button title={logsQuery.isPending ? 'Loading logs...' : 'Refresh logs'} onPress={() => logsQuery.refetch()} />
      <FlatList
        data={logsQuery.data || []}
        keyExtractor={(i) => i.id}
        renderItem={({ item }) => (
          <View style={styles.row}>
            <Text>{item.channel} • {item.status} • {new Date(item.sent_at).toLocaleString()}</Text>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  title: { fontSize: 20, fontWeight: '600', marginBottom: 12 },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 8, marginVertical: 8 },
  row: { paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#eee' },
});
