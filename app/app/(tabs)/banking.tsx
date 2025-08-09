import React, { useState } from 'react';
import { View, FlatList, StyleSheet, Alert } from 'react-native';
import { Screen, H1, PrimaryButton, Card, Label } from '@/components/ui';
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
    <Screen>
      <H1>Banking</H1>
      <PrimaryButton title="List accounts" onPress={fetchAccounts} />
      <PrimaryButton title="Sync" onPress={sync} />
      <FlatList
        data={accounts}
        keyExtractor={(a) => a.id}
        renderItem={({ item }) => (
          <Card><Label>{item.name} • {item.currency}</Label></Card>
        )}
      />
    </Screen>
  );
}

const styles = StyleSheet.create({
  
});
