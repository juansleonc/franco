import { StyleSheet } from 'react-native';

import { Text, View } from '@/components/Themed';
import { useRouter } from 'expo-router';
import { Button } from 'react-native';

export default function TabOneScreen() {
  const router = useRouter();
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Franco</Text>
      <View style={styles.separator} lightColor="#eee" darkColor="rgba(255,255,255,0.1)" />
      <Button title="Go to Notifications" onPress={() => router.push('/(tabs)/notifications')} />
      <Button title="Go to Dunning" onPress={() => router.push('/(tabs)/dunning')} />
      <Button title="Go to Banking" onPress={() => router.push('/(tabs)/banking')} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  separator: {
    marginVertical: 30,
    height: 1,
    width: '80%',
  },
});
