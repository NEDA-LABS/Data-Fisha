package com.fahamutech.smartstock.pos.controllers

import com.fahamutech.smartstock.pos.adapters.CacheAdapter

class CacheController: CacheAdapter<Any> {
    override suspend fun set(identifier: String, data: Any, dtl: List<Any>): Any {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override suspend fun get(identifier: String): Any {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override suspend fun keys(): List<String> {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override suspend fun clearAll(): Boolean {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override suspend fun remove(identifier: String, force: List<Boolean>): Boolean {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
}