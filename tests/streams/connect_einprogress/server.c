#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <arpa/inet.h>
#include <fcntl.h>

int main() {
    // Create socket
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // Set server address and port
    struct sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(8089); // Port number
    server_addr.sin_addr.s_addr = INADDR_ANY;

    // Bind socket to address and port
    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_fd, 3) == -1) {
        perror("listen");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port 8089...\n");

    // Simulate delay before accepting connections
    printf("Simulating delay before accepting connections...\n");
    sleep(20); // 10-second delay

    // // Accept incoming connection
    // struct sockaddr_in client_addr;
    // socklen_t addrlen = sizeof(client_addr);
    // int client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addrlen);
    // if (client_fd == -1) {
    //     perror("accept");
    //     close(server_fd);
    //     exit(EXIT_FAILURE);
    // }

    // printf("Connection accepted from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

    // close(client_fd);
    close(server_fd);
    return 0;
}

