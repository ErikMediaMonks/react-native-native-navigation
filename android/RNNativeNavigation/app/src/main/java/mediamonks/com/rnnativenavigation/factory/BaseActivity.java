package mediamonks.com.rnnativenavigation.factory;

import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;

/**
 * Created by erik on 10/08/2017.
 * RNNativeNavigation 2017
 */

abstract class BaseActivity extends AppCompatActivity
{
	public abstract BaseFragment getFragment();

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case android.R.id.home:
				onBackPressed();
				return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
