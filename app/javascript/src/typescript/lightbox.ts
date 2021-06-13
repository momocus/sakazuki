//@ts-ignore
import SimpleLightbox from 'simplelightbox';

{
    window.addEventListener('DOMContentLoaded', () => {
        new SimpleLightbox('.photo-gallery a', {
            fadeSpeed: 100,
            animationSlide: false,
            history: false,
        });
    });
}
