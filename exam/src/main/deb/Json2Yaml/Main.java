package main.deb.Json2Yaml;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

/*
{
        "version": "-3.9",
        "services": [
            {
                "name": "nginx",
                "image": "nginx:latest",
                "credential_spec": {
                    "config": "my_credential_spec"
                }
            },
            {
                "name": "redis",
                "image": "redis:latest",
                "deploy": {
                    "replicas": 1
                },
                "configs": [
                    "my_config",
                    "my_other_config"
                ]
            }
        ],
        "configs": [
            {
                "name": "my_config",
                "file": "./my_config.txt"
            },
            {
                "name": "my_other_config",
                "external": true
            },
            {
                "name": "my_credential_spec",
                "file": "./my-credential-spec.json"
            }
        ]
}
*/

class Compose {
    public String version;
    public List<Service> services;
    public List<Config> configs;
}

/*
"services": [
    {
        "name": "nginx",
        "image": "nginx:latest",
        "credential_spec": {
            "config": "my_credential_spec"
        }
    },
    {
        "name": "redis",
        "image": "redis:latest",
        "deploy": {
            "replicas": 1
        },
        "configs": [
            "my_config",
            "my_other_config"
        ]
    }
],
*/

class Service {
    public String name;
    public String image;
    public Deploy deploy;
    public CredentialSpec credential_spec;
    public List<String> configs;
}

/*
"deploy": {
         "replicas": 1
},
*/

class Deploy {
    public int replicas;
}

/*
"credential_spec": {
        "config": "my_credential_spec"
}
*/

class CredentialSpec {
    public String config;
}

/*
"configs": [
        {
            "name": "my_config",
            "file": "./my_config.txt"
        },
        {
            "name": "my_other_config",
            "external": true
        },
        {
            "name": "my_credential_spec",
            "file": "./my-credential-spec.json"
        }
]
*/

class Config{
    public String name;
    public String file;
    public String external;
}

public class Main {
    public static void main(String[] args) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper().enable(SerializationFeature.INDENT_OUTPUT);

        Compose compose = objectMapper.readValue(Paths.get("C:\\Users\\arnau\\Documents\\DAM\\M06\\solucions_m06_uf1\\src\\com.company.Json2Yaml\\docker-compose.json").toFile(), Compose.class);

        if(compose.version != null) {
            System.out.println("version: " + compose.version);
        }
        if(compose.services != null) {
            System.out.println("services:");
            for (Service service : compose.services) {
                System.out.println("  - name: " + service.name);

                if (service.image != null) {
                    System.out.println("    image: " + service.image);
                }
                if (service.deploy != null) {
                    System.out.println("    deploy: ");
                    System.out.println("      replicas: " + service.deploy.replicas);
                }
                if (service.credential_spec != null) {
                    System.out.println("    credential_spec:");
                    System.out.println("      config: " + service.credential_spec.config);
                }
                if (service.configs != null) {
                    System.out.println("    configs: ");
                    for (String config : service.configs) {
                        System.out.println("      - " + config);
                    }
                }
            }
        }
        if (compose.configs != null) {
            System.out.println("configs: ");

            for (Config config: compose.configs) {
                System.out.println("  - name: " + config.name);

                if (config.file != null) {
                    System.out.println("    file: " + config.file);
                }
                if (config.external != null) {
                    System.out.println("    external: " + config.external);
                }
            }
        }
    }
}
