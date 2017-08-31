import React, { Component } from 'react';
import { StackView, SingleView, Navigation } from 'react-native-native-navigation';
import Home from './Home';
import Detail from './Detail';
import Loading from './Loading';

export default class example extends Component {
  render() {
    return (
        <Navigation>
          <Loading />
          <StackView>
            <SingleView screen={Home} />
            <SingleView screen={Detail} />
          </StackView>
        </Navigation>
    );
  }
}