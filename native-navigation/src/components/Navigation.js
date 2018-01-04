import React, { Component } from 'react';
import { AppRegistry, View } from 'react-native';
import ReactNativeNativeNavigation from './../ReactNativeNativeNavigation';
import SingleView from './single/SingleView';
import StackView from './stack/StackView';
import TabView from './tab/TabView';
import SplitView from './split/SplitView';
import DrawerView from './drawer/DrawerView';

class Navigation extends Component {

	state = {
		loading: true,
	};
	viewMap = {
		[SingleView.name]: SingleView,
		[StackView.name]: StackView,
		[TabView.name]: TabView,
		[SplitView.name]: SplitView,
		[DrawerView.name]: DrawerView,
	};
	pageMap = null;

	static mapChild = (dom, path) => {
		if (dom.type && typeof(dom.type.mapToDictionary) === 'function') {
			return dom.type.mapToDictionary(dom, path);
		} else if (dom.type) {
			let ComponentClass = dom.type;
			let Component = new ComponentClass();
			if (typeof(Component.render) === 'function') {
				let ComponentRender = Component.render();
				return Navigation.mapChild(ComponentRender, path);
			}
		}
		console.error('RNNN', 'All children of Navigation need to support mapToDictionary');
		return null;
	};
	mapChild = (dom, path) => Navigation.mapChild(dom, path);

	registerScreen = (screenID, screen) => {
		const Screen = screen;
		AppRegistry.registerComponent(screenID, () => {
			const nav = this;
			return class extends Component {
				render() {
					return (
						<Screen navigation={nav}/>
					)
				}
			}
		});
	};

	registerScreens = (screens) => {
		screens.forEach((screenData) => {
			const { screenID, screen } = screenData;
			this.registerScreen(screenID, screen)
		});
	};

	generateSiteMap = () => {
		const dom = this.props.children[1];
		return this.mapChild(dom, '');
	};

	componentDidMount() {
		this.pageMap = this.props.pages.reduce((array, page) => {
			if (page.pageMap) {
				return [
					...array,
					...page.pageMap,
					page,
				]
			} else {
				return [
					...array,
					page,
				];
			}
		}, []).reduce((map, page) => {
			return {
				...map,
				[page.name]: page,
			}
		}, {});
		ReactNativeNativeNavigation.onStart((request) => {
			if (!request) {
				request = this.generateSiteMap();
			}

			if (request) {
				const dom = this.viewMap[request.type];
				const screens = dom.reduceScreens(request, this.viewMap, this.pageMap);
				this.registerScreens(screens);

				ReactNativeNativeNavigation.setSiteMap(request).then((loaded) => {
					this.setState({ loading: !loaded });
				});
			}
		});
	}

	render() {
		if (this.state.loading) {
			return this.props.children[0]
		}

		const { store } = this.props;

		if (this.props.provider && store) {
			return (
				<this.props.provider store={store}>
					<View/>
				</this.props.provider>
			)
		}
		return <View/>
	}
}

module.exports = {
	Navigation,
};

export {
	Navigation,
}
