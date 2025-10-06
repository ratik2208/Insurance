package com.example.hims.dao.impl;

import com.example.hims.dao.PolicyDao;
import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import org.springframework.stereotype.Repository;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

@Repository
public class PolicyDaoImpl implements PolicyDao {

    @PersistenceContext
    private EntityManager em;

    @Override
    public Policy save(Policy policy) {
        em.persist(policy);
        return policy;
    }

    @Override
    public Optional<Policy> findById(Long id) {
        return Optional.ofNullable(em.find(Policy.class, id));
    }

    @Override
    public Optional<Policy> findByPolicyNumber(String policyNumber) {
        List<Policy> list = em.createQuery("SELECT p FROM Policy p WHERE p.policyNumber = :pn", Policy.class)
                              .setParameter("pn", policyNumber)
                              .getResultList();
        return list.stream().findFirst();
    }

    @Override
    public List<Policy> findAll() {
        return em.createQuery("SELECT p FROM Policy p", Policy.class).getResultList();
    }

    @Override
    public List<Policy> findByCreator(User creator) {
        return em.createQuery("SELECT p FROM Policy p WHERE p.createdBy = :creator", Policy.class)
                 .setParameter("creator", creator)
                 .getResultList();
    }

    @Override
    public List<Policy> search(String searchTerm, Boolean active) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Policy> cq = cb.createQuery(Policy.class);
        Root<Policy> root = cq.from(Policy.class);

        Predicate predicate = cb.conjunction();
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String like = "%" + searchTerm.trim().toLowerCase() + "%";
            Predicate byNumber = cb.like(cb.lower(root.get("policyNumber")), like);
            Predicate byTitle = cb.like(cb.lower(root.get("title")), like);
            Predicate byDescription = cb.like(cb.lower(root.get("description")), like);
            predicate = cb.and(predicate, cb.or(byNumber, byTitle, byDescription));
        }
        if (active != null) {
            predicate = cb.and(predicate, cb.equal(root.get("active"), active));
        }

        cq.select(root).where(predicate).orderBy(cb.desc(root.get("id")));
        return em.createQuery(cq).getResultList();
    }

    @Override
    public void update(Policy policy) {
        em.merge(policy);
    }

    @Override
    public void delete(Policy policy) {
        Policy managed = em.contains(policy) ? policy : em.merge(policy);
        em.remove(managed);
    }
}
