package main

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

// Authenticate authenticates the user and generates JWT tokens
func Authenticate(c *gin.Context) {
	var user User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Validate the user credentials (you can replace this with your own authentication logic)
	validUser := user.Username == "admin" && user.Password == "password"

	if !validUser {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// Create JWT token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": user.Username,
		"exp":      time.Now(),
		//"exp":      time.Now().Add(time.Minute * 15).Unix(), // Token expires in 15 minutes
	})

	// Sign the token with the secret key
	tokenString, err := token.SignedString([]byte("your-secret-key")) // Replace "your-secret-key" with your own secret key
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Create refresh token
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": user.Username,
		"exp":      time.Now().Add(time.Hour * 24 * 7).Unix(), // Refresh token expires in 7 days
	})

	// Sign the refresh token with the secret key
	refreshTokenString, err := refreshToken.SignedString([]byte("your-secret-key")) // Replace "your-secret-key" with your own secret key
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return the tokens as a response
	response := TokenResponse{
		Token:        tokenString,
		RefreshToken: refreshTokenString,
	}

	c.JSON(http.StatusOK, response)
}

// RefreshToken generates a new access token using the refresh token
func RefreshToken(c *gin.Context) {
	var refreshRequest struct {
		RefreshToken string `json:"refresh_token"`
	}
	if err := c.ShouldBindJSON(&refreshRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := jwt.Parse(refreshRequest.RefreshToken, func(token *jwt.Token) (interface{}, error) {
		return []byte("your-secret-key"), nil // Replace "your-secret-key" with your own refresh secret key
	})
	if err != nil || !token.Valid {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid refresh token"})
		return
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid refresh token"})
		return
	}

	// Retrieve the username from the refresh token claims
	username, ok := claims["username"].(string)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid refresh token"})
		return
	}

	// Create a new access token for the user
	newToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": username,
		"exp":      time.Now().Add(time.Minute * 15).Unix(), // Token expires in 15 minutes
	})

	// Sign the new token with the secret key
	newTokenString, err := newToken.SignedString([]byte("your-secret-key")) // Replace "your-secret-key" with your own secret key
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	// Create refresh token
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"username": username,
		"exp":      time.Now().Add(time.Hour * 24 * 7).Unix(), // Refresh token expires in 7 days
	})

	// Sign the refresh token with the secret key
	newRefreshTokenString, err := refreshToken.SignedString([]byte("your-secret-key")) // Replace "your-secret-key" with your own secret key
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	// Return the new access token as a response
	response := TokenResponse{
		Token:        newTokenString,
		RefreshToken: newRefreshTokenString,
	}

	c.JSON(http.StatusOK, response)
}
