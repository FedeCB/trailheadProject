public class ucl_Client {

    public String FirstName;
    public String LastName;
    public String Email;
    public String Phone;
    public String Address;
    public String ClientNumber;
    private String clientId;

    ucl_LegalAdvisors legalAdv = new ucl_LegalAdvisors();
    
    public void setClientId(String clientId) {
        this.ClientId = legalAdv.AccountNumber + ClientNumber;
    }
}