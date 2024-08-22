
# **API Gateway Creation for FountainAI: A Step-by-Step Guide**

## **1. Introduction**

This guide provides detailed instructions on how to create and configure an AWS API Gateway for the FountainAI services using an existing OpenAPI specification. This process does not require any AWS-specific extensions in the OpenAPI file, but it involves manual configuration of integrations, security, and other settings within the API Gateway console.

## **2. Uploading the OpenAPI Specification**

### **Step 1: Accessing the API Gateway Console**

1. **Login to AWS Management Console:**
   - Navigate to the [AWS Management Console](https://aws.amazon.com/console/).

2. **Open the API Gateway Service:**
   - In the AWS Management Console, search for "API Gateway" in the search bar and select the API Gateway service.

### **Step 2: Creating a New API**

1. **Create API:**
   - In the API Gateway dashboard, click on "Create API."
   - Choose "REST API" and select "Import from OpenAPI."
   
2. **Upload Your OpenAPI Specification:**
   - Upload the OpenAPI YAML or JSON file. API Gateway will automatically parse the file and create the necessary resources and methods.

3. **Review Resources and Methods:**
   - Once the OpenAPI file is uploaded, review the created resources and methods in the API Gateway console to ensure they match the definitions in your OpenAPI file.

## **3. Configuring Integrations Manually**

Since the OpenAPI file doesn’t include `x-amazon-apigateway-*` extensions, you’ll need to manually configure how each API method interacts with backend services like OpenSearch.

### **Step 1: Accessing Method Integrations**

1. **Select a Resource and Method:**
   - In the API Gateway console, click on a resource (e.g., `/characters`) and then select a method (e.g., `POST`).

2. **Integration Request Setup:**
   - Click on the "Integration Request" section to define how this method should integrate with your backend service.

### **Step 2: Setting Up HTTP Integration**

1. **Choose Integration Type:**
   - Select "HTTP" or "AWS Service" depending on your backend. For OpenSearch, you would typically select "AWS Service."

2. **Define URI and Request Templates:**
   - For **AWS Service**:
     - Choose "OpenSearch Service" as the service type.
     - Define the URI path (e.g., `/domain/_doc/`) to route the request to the correct endpoint in OpenSearch.
   - Configure any necessary request templates to transform incoming requests to the format required by OpenSearch.

   For more details on configuring HTTP integrations, refer to the [AWS API Gateway Developer Guide on Integration Requests](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-integrations.html).

### **Step 3: Setting Up Response Handling**

1. **Integration Response:**
   - Define how responses from OpenSearch are mapped back to the client. This involves setting up integration responses and mapping templates.
   
2. **Method Response:**
   - Configure method responses to define what the API Gateway should return to the client based on the status codes from the backend.

   More information on response mapping can be found in the [AWS API Gateway Response Mapping Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/request-response-data-mappings.html).

## **4. Configuring Security**

### **Step 1: Enforcing HTTPS**

1. **Enable HTTPS:**
   - Ensure that your API Gateway only allows requests over HTTPS. This can be enforced at the stage level by selecting the "Require HTTPS" option.

2. **Set Up Authorization:**
   - Depending on your security needs, configure IAM roles, API keys, or custom authorizers (e.g., Lambda authorizers) for each method.
   
   Refer to [API Gateway Security Features](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-control-access-to-api.html) for more details on securing your API.

### **Step 2: Configuring CORS**

1. **Set Up CORS Headers:**
   - If your API will be accessed by web clients, configure CORS (Cross-Origin Resource Sharing) to allow requests from different domains.
   - CORS can be configured in the method response settings by adding appropriate headers.

   Learn more about configuring CORS in the [API Gateway CORS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html).

## **5. Deploying the API**

### **Step 1: Create a Deployment Stage**

1. **Deploy API:**
   - Once all resources and methods are configured, deploy your API to a stage (e.g., `dev`, `test`, `prod`).
   - In the API Gateway console, click "Deploy API," select or create a new stage, and click "Deploy."

### **Step 2: Testing the API**

1. **Invoke the API:**
   - Use the provided invoke URL for the deployed stage to test your API endpoints.
   - Ensure that requests are correctly routed to OpenSearch, and responses are as expected.

2. **Monitor and Debug:**
   - Use CloudWatch Logs and Metrics to monitor API usage and debug any issues. This can be configured in the stage settings.

   For more information on monitoring and logging, visit [Monitoring and Logging with API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html).

## **6. Future Automation Considerations**

If you find yourself frequently needing to set up integrations, security, and other configurations manually, consider extending your OpenAPI specification with `x-amazon-apigateway-*` extensions in the future. This can automate much of the setup and ensure consistency across deployments.

Learn more about these extensions in the [AWS API Gateway OpenAPI Extensions Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions.html).

---

## **7. Conclusion**

By following this guide, you can effectively create and configure an AWS API Gateway for FountainAI without relying on AWS-specific extensions in your OpenAPI specification. While this approach requires some manual setup, it offers flexibility and control over how your API interacts with backend services like OpenSearch. Ensure that you refer to the official AWS documentation linked throughout this guide for more detailed instructions and best practices.