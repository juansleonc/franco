import { StyleSheet } from 'react-native';

import { useRouter } from 'expo-router';
import { Screen, H1, PrimaryButton, Card } from '@/components/ui';

export default function TabOneScreen() {
  const router = useRouter();
  return (
    <Screen>
      <H1>Franco</H1>
      <Card>
        <PrimaryButton title="Notifications" onPress={() => router.push('/(tabs)/notifications')} />
        <PrimaryButton title="Dunning" onPress={() => router.push('/(tabs)/dunning')} />
        <PrimaryButton title="Banking" onPress={() => router.push('/(tabs)/banking')} />
      </Card>
    </Screen>
  );
}

const styles = StyleSheet.create({
  
});
