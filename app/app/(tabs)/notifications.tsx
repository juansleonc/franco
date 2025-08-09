import React, { useState } from 'react';
import { View, TextInput, FlatList, StyleSheet, Alert } from 'react-native';
import { Screen, H1, PrimaryButton, Card, Label } from '@/components/ui';
import { apiRequest } from '@/lib/api';
import { useMutation, useQuery } from '@tanstack/react-query';
import { ConfirmDialog, useToast } from '@/components/feedback';

type Log = { id: string; invoice_id: string; tenant_id: string; channel: string; status: string; error?: string; sent_at: string };

export default function NotificationsScreen() {
  const [to, setTo] = useState('test@example.com');
  const [phone, setPhone] = useState('+123456');
  const [retryVisible, setRetryVisible] = useState(false);
  const [filters, setFilters] = useState<{ tenant_id?: string; channel?: string; since?: string }>({});
  const toast = useToast();
  const buildQuery = () => {
    const params = new URLSearchParams({ limit: '50' });
    if (filters.tenant_id) params.append('tenant_id', filters.tenant_id);
    if (filters.channel) params.append('channel', filters.channel);
    if (filters.since) params.append('since', filters.since);
    return `/v1/notifications/logs?${params.toString()}`;
  };
  const logsQuery = useQuery({
    queryKey: ['notificationLogs', filters],
    queryFn: async () => (await apiRequest<{ data: Log[] }>(buildQuery())).data,
  });
  const sendEmail = useMutation({
    mutationFn: async () => apiRequest('/v1/notifications/send_test', { method: 'POST', body: { to, subject: 'Hi', body: 'Hello' } }),
    onSuccess: () => toast.show('Email sent'),
    onError: (e: any) => Alert.alert('Error', e.message),
  });
  const sendSms = useMutation({
    mutationFn: async () => apiRequest('/v1/notifications/send_test_sms', { method: 'POST', body: { to: phone, body: 'Test SMS' } }),
    onSuccess: () => toast.show('SMS sent'),
    onError: (e: any) => Alert.alert('Error', e.message),
  });
  const retryFailed = useMutation({
    mutationFn: async () => apiRequest<{ data: { enqueued: number } }>(`/v1/notifications/retry_failed`, { method: 'POST', body: filters }),
    onSuccess: (res) => { toast.show(`Enqueued ${res.data.enqueued}`); setRetryVisible(false); logsQuery.refetch(); },
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
      <Card>
        <Label>Filters</Label>
        <TextInput style={styles.input} placeholder="Tenant ID" value={filters.tenant_id} onChangeText={(v) => setFilters({ ...filters, tenant_id: v || undefined })} />
        <TextInput style={styles.input} placeholder="Channel (email|sms)" value={filters.channel} onChangeText={(v) => setFilters({ ...filters, channel: v || undefined })} />
        <TextInput style={styles.input} placeholder="Since (ISO8601)" value={filters.since} onChangeText={(v) => setFilters({ ...filters, since: v || undefined })} />
        <PrimaryButton title={logsQuery.isPending ? 'Loading logs...' : 'Refresh logs'} onPress={() => logsQuery.refetch()} />
        <PrimaryButton title={retryFailed.isPending ? 'Retrying...' : 'Retry failed (with filters)'} onPress={() => setRetryVisible(true)} />
      </Card>
      <FlatList
        data={logsQuery.data || []}
        keyExtractor={(i) => i.id}
        renderItem={({ item }) => (
          <Card><Label>{new Date(item.sent_at).toLocaleString()}</Label><Label>{item.channel} • {item.status}</Label></Card>
        )}
      />
      <ConfirmDialog
        visible={retryVisible}
        title="Retry failed?"
        message="This will enqueue retries for logs matching filters."
        onCancel={() => setRetryVisible(false)}
        onConfirm={() => retryFailed.mutate()}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  input: { borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 10, padding: 10, marginVertical: 8, backgroundColor: '#fff' },
});
