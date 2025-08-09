import React, { PropsWithChildren } from 'react';
import { View, Text as RNText, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';

export function Screen({ children }: PropsWithChildren) {
  return <View style={styles.screen}>{children}</View>;
}

export function H1({ children }: PropsWithChildren) {
  return <RNText style={styles.h1}>{children}</RNText>;
}

export function Label({ children }: PropsWithChildren) {
  return <RNText style={styles.label}>{children}</RNText>;
}

export function PrimaryButton({ title, onPress, disabled, loading }: { title: string; onPress: () => void; disabled?: boolean; loading?: boolean }) {
  return (
    <TouchableOpacity style={[styles.button, disabled ? styles.buttonDisabled : null]} onPress={onPress} disabled={disabled || loading}>
      {loading ? <ActivityIndicator color="#fff" /> : <RNText style={styles.buttonText}>{title}</RNText>}
    </TouchableOpacity>
  );
}

export function Card({ children }: PropsWithChildren) {
  return <View style={styles.card}>{children}</View>;
}

const styles = StyleSheet.create({
  screen: { flex: 1, padding: 16, backgroundColor: '#f8fafc' },
  h1: { fontSize: 24, fontWeight: '700', marginBottom: 12 },
  label: { fontSize: 14, color: '#64748b', marginBottom: 6 },
  button: { backgroundColor: '#2563eb', paddingVertical: 12, borderRadius: 10, alignItems: 'center', marginVertical: 6 },
  buttonDisabled: { backgroundColor: '#93c5fd' },
  buttonText: { color: '#fff', fontWeight: '600' },
  card: { backgroundColor: '#fff', borderRadius: 12, padding: 12, marginVertical: 8, shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 8, shadowOffset: { width: 0, height: 2 }, elevation: 2 },
});
