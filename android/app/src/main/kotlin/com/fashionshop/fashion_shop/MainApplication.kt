package com.fashionshop.fashion_shop

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Replace with your key from https://developer.tech.yandex.ru/
        MapKitFactory.setApiKey("YOUR_YANDEX_MAPKIT_API_KEY")
    }
}
