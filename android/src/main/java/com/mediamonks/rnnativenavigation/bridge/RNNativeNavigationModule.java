package com.mediamonks.rnnativenavigation.bridge;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactFragmentActivity;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.mediamonks.rnnativenavigation.data.Node;
import com.mediamonks.rnnativenavigation.factory.NodeHelper;
import com.mediamonks.rnnativenavigation.factory.StackFragment;

import java.util.List;

/**
 * Created by erik on 29/08/2017.
 * example 2017
 */

class RNNativeNavigationModule extends ReactContextBaseJavaModule
{
	private static final String kRNNN = "RNNN";

	RNNativeNavigationModule(ReactApplicationContext reactContext)
	{
		super(reactContext);
	}

	@Override
	public String getName()
	{
		return "ReactNativeNativeNavigation";
	}

	@ReactMethod
	public void onStart(Promise promise)
	{
		ReadableMap state = RNNNState.INSTANCE.state;
		if (state != null)
		{
			this.setSiteMap(state, promise);
		}
		else
		{
			Log.i(kRNNN, "First load");
			String message = "A site map is needed to build the views, call setSiteMap";
			promise.reject(kRNNN, message, new Throwable(message));
		}
	}

	@ReactMethod
	public void setSiteMap(ReadableMap map, Promise promise)
	{
		RNNNState.INSTANCE.state = map;

		try
		{
			assert getCurrentActivity() != null;
			ReactFragmentActivity mainActivity = (ReactFragmentActivity) getCurrentActivity();
			ReactApplication mainApplication = (ReactApplication) mainActivity.getApplication();
			ReactNativeHost reactNativeHost = mainApplication.getReactNativeHost();
			ReactInstanceManager reactInstanceManager = reactNativeHost.getReactInstanceManager();
			Node node = NodeHelper.nodeFromMap(map, reactInstanceManager);
			FragmentManager fragmentManager = mainActivity.getSupportFragmentManager();
			FragmentTransaction transaction = fragmentManager.beginTransaction();
			Fragment fragment = node.getFragment();
			transaction.replace(android.R.id.content, fragment);
			transaction.commit();
			promise.resolve(true);
		}
		catch (Exception e)
		{
			promise.reject(kRNNN, "Could not start app", e);
		}
	}

	@ReactMethod
	public void handleBackButton(final Callback callback)
	{
		assert getCurrentActivity() != null;
		ReactFragmentActivity mainActivity = (ReactFragmentActivity) getCurrentActivity();
		List<Fragment> fragments = mainActivity.getSupportFragmentManager().getFragments();
		int leni = fragments.size();
		for (int i = leni - 1; i >= 0; --i)
		{
			final Fragment fragment = fragments.get(i);
			if (fragment instanceof StackFragment)
			{
				mainActivity.runOnUiThread(new Runnable()
				{
					@Override
					public void run()
					{
						StackFragment baseFragment = (StackFragment) fragment;
						callback.invoke(baseFragment.onBackPressed());
					}
				});
				return;
			}
		}
		callback.invoke(false);
	}
}
