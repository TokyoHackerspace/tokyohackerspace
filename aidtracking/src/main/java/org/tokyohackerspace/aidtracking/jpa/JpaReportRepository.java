package org.tokyohackerspace.aidtracking.jpa;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.dao.EmptyResultDataAccessException;
import org.tokyohackerspace.aidtracking.domain.Report;

public class JpaReportRepository implements Repository<Report> {
    
    @PersistenceContext
    private EntityManager em;

    @Override
    public Report getById(long id) throws EmptyResultDataAccessException {
        TypedQuery<Report> q = em.createQuery("select r from Report as r where r.id = :id", Report.class);
        q.setParameter("id", id);
        return q.getSingleResult();
    }

    @Override
    public void save(Report item) {
        em.persist(item);
    }

}
