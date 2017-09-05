import React, { Component } from 'react';
import { Text } from 'react-native';

export default class TabView extends Component {
	static mapChildren = (children, path) => {
		if (!Array.isArray(children)) children = [children];
		return children.map(dom => dom.type.mapToDictionary(dom, path));
	}
	static mapToDictionary = (dom, path) => {
		const type = dom.type.name;
		const tabs = dom.type.mapChildren(dom.props.children, path);
		const selectedTab = dom.props.selectedTab;
		return {
			type,
			tabs,
			selectedTab
		};
	}
	static reduceScreens = (data, viewMap, pageMap) => {
		return data.tabs.reduce((map, node) => {
			const viewData = viewMap[node.type];
			if (viewData) {
				const result = viewData.reduceScreens(node, viewMap, pageMap).map((view) => {
					const { screenID, screen } = view;
					const TabScreen = () => {
						return class extends Component {
							render() {
								const Screen = screen;
								return <Screen {...this.props} />
							}
						}
					}
					const Tab = TabScreen();
					return ({
						screenID,
						screen: Tab,
					})
				});
				return [
					...map,
					...result,
				];
			}
			return map;
		}, []);
	}

	render() {
		const Screen = this.props.screen;
		return <Text>Hmm</Text>;
	}
}