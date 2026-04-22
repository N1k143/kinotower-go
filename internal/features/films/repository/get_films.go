package film_repository

import "github.com/N1k143/kinotower-go/internal/features/films/domain"

func (r *filmRepository) GetFilms() ([]domain.Film, error) {
	return []domain.Film{}, nil
}