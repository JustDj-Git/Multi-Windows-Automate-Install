Function ImportWiFi {
	$profile = Get-Item -Path 'T:\Install\Wifi_Profile\*'
	$profile_path = $profile.FullName
	$profile_name = $profile.Basename
	netsh wlan delete profile "$profile_name" i=* > NULL
	netsh wlan add profile filename="$profile_path" user=all > NULL
	netsh wlan connect name="$profile_name"
}