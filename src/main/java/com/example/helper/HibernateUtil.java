package com.example.helper;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;



/**
 * Utility class for managing Hibernate sessions and transactions manually.
 * <p>
 * This class simplifies session and transaction management by providing
 * reusable methods to execute code blocks within transactional or read-only
 * contexts.
 * </p>
 * <p>
 * It supports:
 * <ul>
 *     <li>Executing code within a read-write transaction</li>
 *     <li>Executing code within a read-only session (no transaction)</li>
 * </ul>
 * </p>
 * <p>
 * Usage example:
 * <pre>
 * HibernateUtil hibernateUtil = new HibernateUtil(sessionFactory);
 *
 * // Save an entity in a transaction
 * hibernateUtil.executeInTransaction(session -> {
 *     session.save(entity);
 *     return null;
 * });
 *
 * // Read entities in read-only mode
 * List&lt;Entity&gt; entities = hibernateUtil.executeReadOnly(session ->
 *     session.createQuery("FROM Entity", Entity.class).list()
 * );
 * </pre>
 * </p>
 */

public class HibernateUtil {

    private final SessionFactory sessionFactory;

    public HibernateUtil(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // For read-write transactions (same as before)
    public <T> T executeInTransaction(HibernateTransactionCallback<T> callback) {
        Transaction tx = null;
        Session session = sessionFactory.openSession();

        try {
            tx = session.beginTransaction();

            T result = callback.doInTransaction(session);

            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Transaction failed", e);
        } finally {
            session.close();
        }
    }

    public <T> T executeReadOnly(HibernateTransactionCallback<T> callback) {
        Session session = sessionFactory.openSession();
        session.setDefaultReadOnly(true);  // Mark the session as read-only

        try {
            return callback.doInTransaction(session); // No transaction needed if only reading
        } finally {
            session.close(); // Still close the session manually
        }
    }
}
