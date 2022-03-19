const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-central-1_OkLKLMFh7",
                        "AppClientId": "6jv8jgmf2s8370ht8i5jj6nlun",
                        "Region": "eu-central-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "OAuth": {
                            "WebDomain": "game-webapp-dev.auth.eu-central-1.amazoncognito.com",
                            "AppClientId": "6jv8jgmf2s8370ht8i5jj6nlun",
                            "SignInRedirectURI": "http://localhost:4200/",
                            "SignOutRedirectURI": "http://localhost:4200/",
                            "Scopes": [
                                "email",
                                "openid"
                            ]
                        }
                    }
                }
            }
        }
    }
}''';
