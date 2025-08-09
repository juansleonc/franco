import * as React from 'react';
import { render, screen } from '@testing-library/react-native';
import { MonoText } from '../StyledText';

it('renders text content', () => {
  render(<MonoText>Snapshot test!</MonoText>);
  expect(screen.getByText('Snapshot test!')).toBeTruthy();
});
