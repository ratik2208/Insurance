package com.example.hims.dao.impl;

import com.example.hims.dao.ClaimDao;
import com.example.hims.entity.Claim;
import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

@Repository
public class ClaimDaoImpl implements ClaimDao {

    @PersistenceContext
    private EntityManager em;

    @Override
    public Claim save(Claim claim) {
        em.persist(claim);
        return claim;
    }

    @Override
    public Optional<Claim> findById(Long id) {
        return Optional.ofNullable(em.find(Claim.class, id));
    }

    // ✅ NEW: Get all claims (for agents and admins)
    @Override
    public List<Claim> findAll() {
        String jpql = "SELECT c FROM Claim c ORDER BY c.claimDate DESC";
        TypedQuery<Claim> query = em.createQuery(jpql, Claim.class);
        return query.getResultList();
    }

    @Override
    public List<Claim> findByCustomer(User customer) {
        return em.createQuery("SELECT c FROM Claim c WHERE c.customer = :cust ORDER BY c.claimDate DESC", Claim.class)
                 .setParameter("cust", customer)
                 .getResultList();
    }

    @Override
    public List<Claim> findByPolicy(Policy policy) {
        return em.createQuery("SELECT c FROM Claim c WHERE c.policy = :p ORDER BY c.claimDate DESC", Claim.class)
                 .setParameter("p", policy)
                 .getResultList();
    }

    @Override
    public List<Claim> search(String searchTerm, String status) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Claim> cq = cb.createQuery(Claim.class);
        Root<Claim> root = cq.from(Claim.class);

        Predicate predicate = cb.conjunction();
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String like = "%" + searchTerm.trim().toLowerCase() + "%";
            Predicate byNumber = cb.like(cb.lower(root.get("claimNumber")), like);
            Predicate byPolicy = cb.like(cb.lower(root.get("policy").get("policyNumber")), like);
            Predicate byCustomer = cb.like(cb.lower(root.get("customer").get("name")), like);
            predicate = cb.and(predicate, cb.or(byNumber, byPolicy, byCustomer));
        }
        
        if (status != null && !status.trim().isEmpty()) {
            predicate = cb.and(predicate, cb.equal(cb.upper(root.get("status")), status.trim().toUpperCase()));
        }

        cq.select(root).where(predicate).orderBy(cb.desc(root.get("claimDate")));
        return em.createQuery(cq).getResultList();
    }

    @Override
    public boolean existsByPolicyAndCustomer(Policy policy, User customer) {
        Long count = em.createQuery(
            "SELECT COUNT(c) FROM Claim c WHERE c.policy = :p AND c.customer = :cust", 
            Long.class
        )
        .setParameter("p", policy)
        .setParameter("cust", customer)
        .getSingleResult();
        return count != null && count > 0;
    }

    @Override
    public void update(Claim claim) {
        em.merge(claim);
    }

    @Override
    public void delete(Claim claim) {
        Claim managed = em.contains(claim) ? claim : em.merge(claim);
        em.remove(managed);
    }
}
