package com.example.nearby_cross.utils

class InterfaceUtils {
    companion object {
        @JvmStatic
        fun parseStringAsBoolean(strNumber: String): Boolean {
            return strNumber.toIntOrNull() == 1
        }
    }
}