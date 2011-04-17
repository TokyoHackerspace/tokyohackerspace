package org.tokyohackerspace.aidtracking.domain;

import java.util.Date;

public class Comment {

    private Long id;
    private Long reportId;
    private String commenterOpenIdUrl;
    private String body;
    private Date createdDate;
    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getReportId() {
        return reportId;
    }
    public void setReportId(Long reportId) {
        this.reportId = reportId;
    }
    public String getCommenterOpenIdUrl() {
        return commenterOpenIdUrl;
    }
    public void setCommenterOpenIdUrl(String commenterOpenIdUrl) {
        this.commenterOpenIdUrl = commenterOpenIdUrl;
    }
    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }
    public Date getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    
   
}
