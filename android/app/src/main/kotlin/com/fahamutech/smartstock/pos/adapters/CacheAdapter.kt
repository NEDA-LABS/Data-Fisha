package com.fahamutech.smartstock.pos.adapters

interface CacheAdapter<T> {
    suspend fun set(identifier: String, data: T, dtl: List<T>): T
    suspend fun get(identifier: String): T
    suspend fun keys(): List<String>
    suspend fun clearAll(): Boolean
    suspend fun remove(identifier: String, force: List<Boolean>): Boolean
}