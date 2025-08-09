import React, { useState } from 'react';
import { View, Button, FlatList, StyleSheet, Alert } from 'react-native';
import { Text } from '@/components/Themed';
import { apiRequest } from '@/lib/api';

type Account = { id: string; name: string; currency: string };

export default function BankingScreen() {
  const [accounts, setAccounts] = useState<Account[]>([]);

  const fetchAccounts = async () => {
    try {
      const res = await apiRequest<{ data: Account[] }>(`/v1/banking/accounts`);
      setAccounts(res.data);
    } catch (e: any) {
      Alert.alert('Error', e.message);
    }
  };

  const sync = async () => {
    try {
      const res = await apiRequest<{ data: any }>(`/v1/banking/sync`, { method: 'POST', body: {} });
      Alert.alert('Synced', JSON.stringify(res.data));
    } catch (e: any) {
      Alert.alert('Error', e.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Banking</Text>
      <Button title="List accounts" onPress={fetchAccounts} />
      <Button title="Sync" onPress={sync} />
      <FlatList
        data={accounts}
        keyExtractor={(a) => a.id}
        renderItem={({ item }) => (
          <View style={styles.row}><Text>{item.name} • {item.currency}</Text></View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  title: { fontSize: 20, fontWeight: '600', marginBottom: 12 },
  row: { paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: '#eee' },
});
