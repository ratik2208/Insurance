package com.example.hims.exception;

public class UserEmailExistException extends RuntimeException {
    public UserEmailExistException(String message) {
        super(message);
    }
}
