package org.tokyohackerspace.aidtracking.jpa;

import org.springframework.dao.EmptyResultDataAccessException;

public interface Repository<T> {

    public T getById(long id) throws EmptyResultDataAccessException;
    
    public void save(T item);
}
