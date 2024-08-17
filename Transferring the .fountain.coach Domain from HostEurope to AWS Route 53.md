# **Transferring the `.fountain.coach` Domain from HostEurope to AWS Route 53**

## **Abstract**

This document outlines the process of transferring the `.fountain.coach` domain from HostEurope to AWS Route 53. The transfer will enable centralized management of domain and DNS settings within the AWS ecosystem, providing better integration with AWS services and simplifying infrastructure scaling and management. This paper will guide you through each step, from preparing for the transfer at HostEurope to configuring DNS settings in Route 53 post-transfer.

## **1. Introduction**

The domain transfer process involves several key steps, including unlocking the domain, obtaining the EPP code, initiating the transfer in AWS Route 53, and setting up DNS records in the AWS environment. This document is intended to serve as a reference for IT professionals and administrators managing domain migrations to AWS Route 53.

## **2. Preparation for Domain Transfer**

### 2.1 Unlock the Domain at HostEurope

1. Log into your HostEurope account.
2. Navigate to the domain management section.
3. Unlock the `.fountain.coach` domain if it is currently locked. This step is crucial to prevent unauthorized domain transfers.

### 2.2 Obtain the Authorization Code (EPP Code)

1. Request the EPP code from HostEurope. The EPP code is necessary to authorize the domain transfer to AWS Route 53.

### 2.3 Verify Domain Contact Information

1. Ensure that the domain's contact information, particularly the email address, is up to date. AWS will send important transfer approval emails to this address.

## **3. Initiating the Transfer in AWS Route 53**

### 3.1 Log into AWS Management Console

1. Navigate to the **Route 53** service within the AWS Management Console.

### 3.2 Start the Transfer Process

1. In the Route 53 dashboard, select **Registered Domains**.
2. Click on **Transfer Domain**.
3. Enter `fountain.coach` as the domain name and select **Check**.

### 3.3 Enter the Authorization Code

1. When prompted, enter the EPP code obtained from HostEurope.

### 3.4 Choose Contact and Privacy Settings

1. Review and confirm the contact details for the domain.
2. Choose whether to enable WHOIS privacy protection.

### 3.5 Configure DNS Settings

1. You can either import your existing DNS settings or manually configure new ones in Route 53.

### 3.6 Confirm and Initiate the Transfer

1. Review the transfer settings and costs.
2. Confirm that you wish to transfer the domain to AWS Route 53.

## **4. Completing the Domain Transfer**

### 4.1 Approve the Transfer

1. Approve the transfer via the email sent to the domain’s administrative contact. This step will expedite the process.

### 4.2 Wait for the Transfer to Complete

1. The transfer can take up to 7 days but often completes more quickly.
2. During this period, the domain should remain functional.

### 4.3 Check Domain Status

1. Monitor the status of the transfer in the Route 53 console under **Pending Requests**.
2. Once completed, the domain will be listed under **Registered Domains** in Route 53.

## **5. Setting Up DNS in Route 53**

### 5.1 Create a Hosted Zone

1. If a hosted zone wasn’t created during the transfer, create one for `fountain.coach` in Route 53.
2. Enter `fountain.coach` as the domain name and select **Public Hosted Zone**.

### 5.2 Recreate DNS Records

1. If DNS records were not imported, manually recreate them in the Route 53 hosted zone.
2. Add records such as A, CNAME, MX, and others as required.

### 5.3 Update Name Servers at HostEurope

1. If not automatically updated, log into HostEurope and update the name servers to the ones provided by AWS Route 53.

## **6. Monitoring and Verification**

### 6.1 DNS Propagation

1. DNS changes can take up to 48 hours to propagate fully. Use tools like `nslookup`, `dig`, or online DNS checkers to verify that DNS records are correctly resolving.

### 6.2 Testing

1. Test your services to ensure they are resolving correctly with the new Route 53 settings.

### 6.3 Finalization

1. After the transfer and DNS setup are complete, manage your domain entirely within AWS Route 53.

## **7. Conclusion**

Transferring the `.fountain.coach` domain from HostEurope to AWS Route 53 centralizes domain and DNS management within the AWS ecosystem, streamlining operations and improving integration with AWS services. This document provides a comprehensive guide for IT professionals looking to efficiently and effectively manage domain transfers to AWS.

---

### **References**

- AWS Route 53 Documentation: [https://aws.amazon.com/route53/](https://aws.amazon.com/route53/)
- HostEurope Support: [https://www.hosteurope.de/](https://www.hosteurope.de/)

---

This document should serve as a comprehensive guide for transferring your domain from HostEurope to AWS Route 53, with all necessary steps and considerations clearly outlined. If you need further details or have additional requirements, feel free to expand on this document.