package org.tokyohackerspace.aidtracking.domain;

import java.util.Date;

public class Report {

    private Long id;
    private boolean requestForAid;
    private String reporterOpenIdUrl;
    private String locationName;
    private Boolean shelter;
    private String body;
    private boolean satisfied;
    private Double latitude;
    private Double longitude;
    private String address;
    private String city;
    private String prefecture;
    private String zipcode;
    private Date validAsOfDate;
    private Date createdDate;
    
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public boolean isRequestForAid() {
        return requestForAid;
    }
    public void setRequestForAid(boolean requestForAid) {
        this.requestForAid = requestForAid;
    }
    public String getReporterOpenIdUrl() {
        return reporterOpenIdUrl;
    }
    public void setReporterOpenIdUrl(String reporterOpenIdUrl) {
        this.reporterOpenIdUrl = reporterOpenIdUrl;
    }
    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }
    public Double getLatitude() {
        return latitude;
    }
    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
    public Double getLongitude() {
        return longitude;
    }
    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getPrefecture() {
        return prefecture;
    }
    public void setPrefecture(String prefecture) {
        this.prefecture = prefecture;
    }
    public String getZipcode() {
        return zipcode;
    }
    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }
    public Date getValidAsOfDate() {
        return validAsOfDate;
    }
    public void setValidAsOfDate(Date validAsOfDate) {
        this.validAsOfDate = validAsOfDate;
    }
    public Date getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }
    public String getLocationName() {
        return locationName;
    }
    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }
    public Boolean isShelter() {
        return shelter;
    }
    public void setShelter(Boolean shelter) {
        this.shelter = shelter;
    }
    public boolean isSatisfied() {
        return satisfied;
    }
    public void setSatisfied(boolean satisfied) {
        this.satisfied = satisfied;
    }
    
   
}
