#include <stdio.h>

int main (void) 
{
	int dia, mes, ano;
	int a, b, c, dia_semana;

	printf("Digite o dia: ");
	scanf("%d", &dia);

	printf("Digite o mês: ");
	scanf("%d", &mes);

	printf("Digite o ano: ");
	scanf("%d", &ano);

	if (mes == 1)
	{	
		a = mes + 12;
		ano--;
	}
	else if (mes == 2)
	{
		a = mes + 12;
		ano--;
	}
	else
		a = mes;
	
	b = ano % 100;
	c = ano / 100;
	dia_semana = (dia + (((a+1) * 26) / 10) + b + b/4 + c/4 + c*5) % 7;
	
	if (dia_semana == 0)
	    printf("O dia da semana é sábado!");
	if (dia_semana == 1)
	    printf("O dia da semana é domingo!");
	if (dia_semana == 2)
	    printf("O dia da semana é segunda-feira!");
	if (dia_semana == 3)
	    printf("O dia da semana é terça-feira!");
	if (dia_semana == 4)
		printf("O dia da semana é quarta-feira!");
	if (dia_semana == 5)
		printf("O dia da semana é quinta-feira!");
	if (dia_semana == 6)
		printf("O dia da semana é sexta-feira!");
	
	return 0;
}