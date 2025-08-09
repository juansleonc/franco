import React, { useState } from 'react';
import { View, Button, FlatList, TextInput, StyleSheet, Alert } from 'react-native';
import { Text } from '@/components/Themed';
import { apiRequest } from '@/lib/api';

type Candidate = { invoice_id: string; tenant_id: string; stage: string; email?: string; phone?: string };

export default function DunningScreen() {
  const [asOf, setAsOf] = useState<string>('');
  const [data, setData] = useState<Candidate[]>([]);
  const [loading, setLoading] = useState(false);

  const preview = async () => {
    setLoading(true);
    try {
      const res = await apiRequest<{ data: Candidate[] }>(`/v1/dunning/preview${asOf ? `?as_of=${asOf}` : ''}`);
      setData(res.data);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally {
      setLoading(false);
    }
  };

  const sendBulk = async () => {
    if (data.length === 0) return;
    setLoading(true);
    try {
      const invoice_ids = data.map(d => d.invoice_id);
      const res = await apiRequest<{ data: { enqueued: number; throttled: number } }>(`/v1/dunning/send_bulk`, {
        method: 'POST',
        body: { invoice_ids, channels: ['email', 'sms'] },
      });
      Alert.alert('Enqueued', `enqueued=${res.data.enqueued}, throttled=${res.data.throttled}`);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Dunning</Text>
      <TextInput style={styles.input} placeholder="As of (YYYY-MM-DD)" value={asOf} onChangeText={setAsOf} />
      <Button title={loading ? 'Loading...' : 'Preview'} onPress={preview} />
      <Button title="Send Bulk (email+sms)" onPress={sendBulk} disabled={data.length === 0 || loading} />
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
