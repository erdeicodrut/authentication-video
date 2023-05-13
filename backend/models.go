package main

// User represents the user credentials
type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// TokenResponse represents the response structure for authentication endpoints
type TokenResponse struct {
	Token        string `json:"token"`
	RefreshToken string `json:"refresh_token"`
}

// Name represents a single name in the database
type Name struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}
