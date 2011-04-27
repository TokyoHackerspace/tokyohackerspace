package org.tokyohackerspace.aidtracking.resource;

import javax.inject.Inject;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.stereotype.Component;
import org.tokyohackerspace.aidtracking.domain.Report;
import org.tokyohackerspace.aidtracking.jpa.Repository;

@Path("report")
@Component
@Configurable
public class ReportResource {
    
    @Inject 
    private Repository<Report> reportRepository;

    @GET
    @Path("{id}")
    @Produces("application/json")
    public Report get(@PathParam("id") String id)  {
        return new Report();
    }


    @POST
    @Path("request/create")
    public void createRequest(@FormParam("location") String id)  {
    }

    @POST
    @Path("delivery/create")
    @Produces("application/json")
    public Report createDelivery(@FormParam("location") String location,
            @FormParam("shelter") String shelter,
            @FormParam("body") String body,
            @FormParam("latitude") String latitude,
            @FormParam("longitude") String longitude,
            @FormParam("address") String address,
            @FormParam("city") String city,
            @FormParam("prefecture") String prefecture,
            @FormParam("zipcode") String zipcode,
            @FormParam("validDate") String validDate)  {
        
        // Do validation
        
        Report report = new Report();
        
        
        this.reportRepository.save(report);
        return report;
    }

    
    
}
