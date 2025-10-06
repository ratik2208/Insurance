package com.example.helper;

import org.hibernate.Session;

@FunctionalInterface
public interface HibernateTransactionCallback<T> {
	T doInTransaction(Session session);
}
