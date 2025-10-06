package com.example.hims.dao.impl;

import com.example.hims.dao.UserDao;
import com.example.hims.entity.User;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDaoImpl implements UserDao {

    @PersistenceContext
    private EntityManager em;

    @Override
    public User save(User user) {
        em.persist(user);
        return user;
    }

    @Override
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(em.find(User.class, id));
    }

    @Override
    public Optional<User> findByEmail(String email) {
        List<User> list = em.createQuery("SELECT u FROM User u WHERE u.email = :e", User.class)
                .setParameter("e", email)
                .getResultList();
        return list.stream().findFirst();
    }

    @Override
    public boolean existsByEmail(String email) {
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.email = :e", Long.class)
                .setParameter("e", email)
                .getSingleResult();
        return count != null && count > 0;
    }

    @Override
    public void update(User user) {
        em.merge(user);
    }

    @Override
    public void delete(User user) {
        User managed = em.contains(user) ? user : em.merge(user);
        em.remove(managed);
    }

    @Override
    public List<User> findAll() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    @Override
    public long countAll() {
        Long count = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countByRole(String roleName) {
        Long count = em.createQuery("SELECT COUNT(u) FROM User u WHERE UPPER(u.role) = :r", Long.class)
                .setParameter("r", roleName.toUpperCase())
                .getSingleResult();
        return count == null ? 0 : count;
    }

    @Override
    public long countRegisteredBetween(LocalDateTime from, LocalDateTime to) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Long> cq = cb.createQuery(Long.class);
        Root<User> root = cq.from(User.class);
        Predicate p = cb.between(root.get("createdAt"), from, to);
        cq.select(cb.count(root)).where(p);
        Long count = em.createQuery(cq).getSingleResult();
        return count == null ? 0 : count;
    }
}
