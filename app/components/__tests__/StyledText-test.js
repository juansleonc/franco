import * as React from 'react';
import renderer, { act } from 'react-test-renderer';

import { MonoText } from '../StyledText';

it(`renders correctly`, () => {
  let component;
  act(() => {
    component = renderer.create(<MonoText>Snapshot test!</MonoText>);
  });
  expect(component.toJSON()).toMatchSnapshot();
  component.unmount();
});
