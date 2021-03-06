import React, { Component } from 'react';
import { Button, processColor, Text, View } from 'react-native';
import Detail from '../Detail';
import Detail2 from "../Detail2";
import { SingleView } from "react-native-native-navigation";

export default class Menu extends Component {
	static pageMap = [Detail];

	handleMenuItem = (view) => {
		this.props.stack.push(view);
	};

	render() {
		return (
			<View>
				<Text>Menu</Text>
				<Button title="Detail" onPress={() => this.handleMenuItem(
					<SingleView id="Detail" screen={Detail} style={{
						title: 'Detail',
						barBackground: processColor('#ff0'),
						barTint: processColor('#f00'),
					}}/>
				)}/>
				<Button title="Detail 2" onPress={() => this.handleMenuItem(
					<SingleView id="Detail2" screen={Detail2} style={{
						title: 'Detail2',
						barBackground: processColor('#f0f'),
						barTransparent: true,
						barTint: processColor('#0f0'),
					}}/>
				)}/>
			</View>
		);
	}
}
