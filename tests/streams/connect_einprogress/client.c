#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/poll.h>
#include <fcntl.h>

int main() {
    // Create socket
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // Set server address and port
    struct sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(8089); // Port number
    inet_aton("127.0.0.1", &server_addr.sin_addr); // IP address of the server

    // Set socket to non-blocking
    if (fcntl(sockfd, F_SETFL, O_NONBLOCK) < 0) {
        perror("fcntl");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // Connect to server
    int result = connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (result == -1 && errno == EINPROGRESS) {
        printf("Connection in progress (EINPROGRESS).\n");

        // Wait for connection using poll
        struct pollfd fds[1];
        fds[0].fd = sockfd;
        fds[0].events = POLLOUT;

        int poll_result = poll(fds, 1, 10000); // 10-second timeout
        if (poll_result == -1) {
            perror("poll");
            close(sockfd);
            exit(EXIT_FAILURE);
        } else if (poll_result == 0) {
            printf("Connection timeout.\n");
            close(sockfd);
            exit(EXIT_FAILURE);
        } else {
            // Connection established or error occurred
            if (fds[0].revents & POLLOUT) {
                int error = 0;
                socklen_t len = sizeof(error);
                if (getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &error, &len) < 0) {
                    perror("getsockopt");
                    close(sockfd);
                    exit(EXIT_FAILURE);
                }
                if (error != 0) {
                    fprintf(stderr, "Error in connecting: %s\n", strerror(error));
                    close(sockfd);
                    exit(EXIT_FAILURE);
                }
                printf("Connection established %d : %d.\n", errno, error);
            } else {
                fprintf(stderr, "Unknown error occurred.\n");
                close(sockfd);
                exit(EXIT_FAILURE);
            }
        }
    } else if (result == 0) {
        if (errno == EINPROGRESS) {
            printf("Connection in progress.\n");
        } else {
            printf("Connection established.\n");
        }
    } else {
        perror("connect");
        exit(EXIT_FAILURE);
    }

    close(sockfd);
    return 0;
}
