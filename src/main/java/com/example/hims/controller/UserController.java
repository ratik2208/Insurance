package com.example.hims.controller;

import com.example.hims.dao.UserDao;
import com.example.hims.dto.UserStatsDTO;
import com.example.hims.entity.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired private UserDao userRepository;
    @Autowired private com.example.hims.service.UserService userService;

    @GetMapping
    public List<User> listUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUser(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Admin-only role change endpoint (security should restrict it)
    @PutMapping("/{id}/role")
    public ResponseEntity<?> changeRole(@PathVariable Long id, @RequestParam String role) {
        return userRepository.findById(id).map(u -> {
            u.setRole(Enum.valueOf(com.example.hims.entity.Role.class, role.toUpperCase()));
            userRepository.save(u);
            return ResponseEntity.ok("Role updated");
        }).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/stats")
    public UserStatsDTO getStats() {
        UserStatsDTO dto = new UserStatsDTO();
        dto.setTotalUsers(userService.countAll());
        dto.setAdminCount(userService.countByRole("ADMIN"));
        dto.setAgentCount(userService.countByRole("AGENT"));
        dto.setCustomerCount(userService.countByRole("CUSTOMER"));
        dto.setRegisteredToday(userService.countRegisteredToday());
        dto.setRegisteredLast7Days(userService.countRegisteredLast7Days());
        return dto;
    }
}
