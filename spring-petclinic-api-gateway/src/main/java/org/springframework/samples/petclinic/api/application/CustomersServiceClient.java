/*
 * Copyright 2002-2021 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.samples.petclinic.api.application;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.samples.petclinic.api.dto.OwnerDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

/**
 * @author Maciej Szarlinski
 */
@Component
public class CustomersServiceClient {

    private final WebClient.Builder webClientBuilder;
    private String hostname;

    public CustomersServiceClient(WebClient.Builder webClientBuilder) {
        this(webClientBuilder, "http://customers-service:8080");
    }

    @Autowired
    public CustomersServiceClient(WebClient.Builder webClientBuilder,
                                  @Value("${CUSTOMERS_SERVICE_URL:http://customers-service:8080}") String hostname) {
        this.webClientBuilder = webClientBuilder;
        setHostname(hostname);
    }

    public Mono<OwnerDetails> getOwner(final int ownerId) {
        return webClientBuilder.build().get()
            .uri(hostname + "/owners/{ownerId}", ownerId)
            .retrieve()
            .bodyToMono(OwnerDetails.class);
    }

    public void setHostname(String hostname) {
        this.hostname = (hostname != null && hostname.endsWith("/")) ? hostname.substring(0, hostname.length() - 1) : hostname;
    }
}
