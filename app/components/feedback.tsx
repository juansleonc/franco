import React, { createContext, useCallback, useContext, useMemo, useState, PropsWithChildren } from 'react';
import { View, Text, StyleSheet, Modal, TouchableOpacity } from 'react-native';

// Toast
interface ToastContextValue {
  show: (message: string) => void;
}
const ToastContext = createContext<ToastContextValue | undefined>(undefined);

export function ToastProvider({ children }: PropsWithChildren) {
  const [message, setMessage] = useState<string | null>(null);

  const show = useCallback((msg: string) => {
    setMessage(msg);
    setTimeout(() => setMessage(null), 2500);
  }, []);

  const value = useMemo(() => ({ show }), [show]);

  return (
    <ToastContext.Provider value={value}>
      {children}
      {message && (
        <View pointerEvents="none" style={styles.toastWrap}>
          <View style={styles.toast}><Text style={styles.toastText}>{message}</Text></View>
        </View>
      )}
    </ToastContext.Provider>
  );
}

export function useToast() {
  const ctx = useContext(ToastContext);
  if (!ctx) throw new Error('useToast must be used within ToastProvider');
  return ctx;
}

// Confirm Dialog
export function ConfirmDialog({ visible, title, message, confirmText = 'Confirm', cancelText = 'Cancel', onConfirm, onCancel }: {
  visible: boolean;
  title: string;
  message?: string;
  confirmText?: string;
  cancelText?: string;
  onConfirm: () => void;
  onCancel: () => void;
}) {
  return (
    <Modal visible={visible} transparent animationType="fade">
      <View style={styles.modalBackdrop}>
        <View style={styles.modalCard}>
          <Text style={styles.modalTitle}>{title}</Text>
          {!!message && <Text style={styles.modalMsg}>{message}</Text>}
          <View style={styles.modalActions}>
            <TouchableOpacity style={[styles.btn, styles.btnGhost]} onPress={onCancel}><Text style={styles.btnGhostText}>{cancelText}</Text></TouchableOpacity>
            <TouchableOpacity style={[styles.btn, styles.btnPrimary]} onPress={onConfirm}><Text style={styles.btnPrimaryText}>{confirmText}</Text></TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  toastWrap: { position: 'absolute', bottom: 24, left: 0, right: 0, alignItems: 'center' },
  toast: { backgroundColor: 'rgba(0,0,0,0.85)', paddingVertical: 10, paddingHorizontal: 16, borderRadius: 8 },
  toastText: { color: '#fff' },
  modalBackdrop: { flex: 1, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'center', alignItems: 'center', padding: 24 },
  modalCard: { backgroundColor: '#fff', borderRadius: 12, padding: 16, width: '100%', maxWidth: 420 },
  modalTitle: { fontSize: 18, fontWeight: '700', marginBottom: 8 },
  modalMsg: { fontSize: 14, color: '#475569', marginBottom: 16 },
  modalActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 12 },
  btn: { paddingVertical: 10, paddingHorizontal: 14, borderRadius: 8 },
  btnPrimary: { backgroundColor: '#2563eb' },
  btnPrimaryText: { color: '#fff', fontWeight: '600' },
  btnGhost: { backgroundColor: 'transparent' },
  btnGhostText: { color: '#2563eb', fontWeight: '600' },
});
