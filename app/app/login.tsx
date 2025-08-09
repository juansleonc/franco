import React, { useState } from 'react';
import { View, TextInput, StyleSheet, Alert, Image } from 'react-native';
import { Screen, H1, PrimaryButton, Label } from '@/components/ui';
import { login, logout } from '@/lib/api';
import { useRouter } from 'expo-router';

export default function LoginScreen() {
  const [email, setEmail] = useState('admin@example.com');
  const [password, setPassword] = useState('Password123!');
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const onLogin = async () => {
    setLoading(true);
    try {
      await login(email, password);
      router.replace('(tabs)');
    } catch (e: any) {
      Alert.alert('Login failed', e.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Screen>
      <View style={styles.header}>
        <Image source={require('../assets/images/icon.png')} style={styles.logo} />
        <H1>Welcome to Franco</H1>
      </View>
      <Label>Email</Label>
      <TextInput style={styles.input} autoCapitalize="none" placeholder="Email" value={email} onChangeText={setEmail} />
      <Label>Password</Label>
      <TextInput style={styles.input} placeholder="Password" secureTextEntry value={password} onChangeText={setPassword} />
      <PrimaryButton title={loading ? 'Logging in...' : 'Login'} onPress={onLogin} disabled={loading} />
      <PrimaryButton title="Logout (clear token)" onPress={async () => { await logout(); }} />
    </Screen>
  );
}

const styles = StyleSheet.create({
  header: { alignItems: 'center', marginBottom: 16 },
  logo: { width: 64, height: 64, marginBottom: 8 },
  input: { width: '100%', borderWidth: 1, borderColor: '#e2e8f0', borderRadius: 10, padding: 12, marginBottom: 12, backgroundColor: '#fff' },
});
