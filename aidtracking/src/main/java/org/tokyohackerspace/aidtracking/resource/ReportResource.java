package org.tokyohackerspace.aidtracking.resource;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;

import org.tokyohackerspace.aidtracking.domain.Report;

@Path("report")
public class ReportResource {

    @GET
    @Path("{id}")
    public Report get(@PathParam("id") String id)  {
        return null;
    }


    @POST
    @Path("create")
    public Report create(@PathParam("id") String id)  {
        return null;
    }
    
}
