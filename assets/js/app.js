/**
 * Smartphone Behavior Analysis Dashboard
 * Main Interactvity Script
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Mobile Navigation Toggle
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.querySelector('.nav-links');

    if (menuToggle && navLinks) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
        });
    }

    // Close mobile menu on click
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', () => {
            navLinks.classList.remove('active');
        });
    });

    // 2. Scroll Animation (Fade In)
    const faders = document.querySelectorAll('.fade-in');
    const appearOptions = {
        threshold: 0.15,
        rootMargin: "0px 0px -50px 0px"
    };

    const appearOnScroll = new IntersectionObserver(function(entries, observer) {
        entries.forEach(entry => {
            if (!entry.isIntersecting) {
                return;
            } else {
                entry.target.classList.add('appear');
                observer.unobserve(entry.target);
            }
        });
    }, appearOptions);

    faders.forEach(fader => {
        appearOnScroll.observe(fader);
    });

    // 3. Navbar Background on Scroll
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(13, 17, 23, 0.9)';
            navbar.style.boxShadow = '0 4px 30px rgba(0, 0, 0, 0.5)';
        } else {
            navbar.style.background = 'rgba(13, 17, 23, 0.7)';
            navbar.style.boxShadow = 'none';
        }
    });
});

// 4. Modal Logic for Image Gallery
const modal = document.getElementById("imageModal");
const modalImg = document.getElementById("expandedImg");
const captionText = document.getElementById("modalCaption");

// Function triggered by inline onclick on gallery items
function openModal(imgSrc, caption) {
    if (modal && modalImg && captionText) {
        modal.style.display = "flex";
        
        // Small delay to allow display flex to apply before opacity fades in
        setTimeout(() => {
            modal.classList.add("show");
        }, 10);
        
        modalImg.src = imgSrc;
        captionText.innerHTML = caption;
        
        // Prevent background scrolling
        document.body.style.overflow = "hidden";
    }
}

function closeModal() {
    if (modal) {
        modal.classList.remove("show");
        
        // Wait for transition before hiding
        setTimeout(() => {
            modal.style.display = "none";
        }, 300);
        
        // Restore background scrolling
        document.body.style.overflow = "auto";
    }
}

// Close modal when clicking outside the image
if (modal) {
    modal.addEventListener('click', function(e) {
        if (e.target !== modalImg) {
            closeModal();
        }
    });
}
