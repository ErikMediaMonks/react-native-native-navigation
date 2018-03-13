import React, { Component } from 'react';
import { Button, View, Text } from 'react-native';
import Detail from '../Detail';
import Home from "../Home";
import Detail2 from "../Detail2";
import { SingleView, StackView } from "../../../native-navigation/src/index";

export default class Menu extends Component {
	static pageMap = [Detail];
	handleMenuItem = (view) => {
		this.props.split.replace('second', view)
	};

	render() {
		return (
			<View>
				<Text>Menu</Text>
				<Button title="Detail" onPress={() => this.handleMenuItem(
					<SingleView id="Detail" screen={Detail}/>
				)}/>
				<Button title="Detail 2" onPress={() => this.handleMenuItem(
					<SingleView id="Detail2" screen={Detail2}/>
				)}/>
			</View>
		);
	}
}
