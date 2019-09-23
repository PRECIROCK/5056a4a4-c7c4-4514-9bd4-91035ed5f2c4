import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


class Amortization(object):

    def init(self, amount, interest, n):
        self.amount = amount
        self.interest = interest
        self.n = n

    def annuity(self):
        annuity = self.amount / ((1 - (1 + self.interest) ** (-self.n)) / self.interest)
        return annuity

    def get_table(self):
        Annuity = self.annuity()
        Principal_l = [0]
        Interest_l = [0]
        Annuity_l = [Annuity]
        Loan_Val_l = [self.amount]

        for j in range(self.n):
            Annuity_l.append(Annuity_l[-1])
            Interest_l.append(Loan_Val_l[-1] * (self.interest))
            Principal_l.append(Annuity_l[-1] - Interest_l[-1])
            Loan_Val_l.append(Loan_Val_l[-1] - Principal_l[-1])

        table = pd.DataFrame([Principal_l, Interest_l, Annuity_l, Loan_Val_l]).transpose()
        table = table.rename(columns={0: 'Principal', 1: 'Interest', 2: 'Annuity', 3: 'Loan Value'})
        return table


    def get_plot(self):
        table = self.get_table()
        fig = plt.figure(1)
        plt.subplot(2, 2, 1)
        plt.plot(list(np.arange(self.n) + 1), list(table.iloc[1:, 0]))
        plt.title('Principal')
        plt.xlabel('Periods')
        plt.ylabel('Amount $')
        plt.subplot(2, 2, 2)
        plt.plot(list(np.arange(self.n) + 1), list(table.iloc[1:, 1]))
        plt.title('Interest')
        plt.xlabel('Periods')
        plt.ylabel('Interest $')
        plt.subplot(2, 2, 3)
        plt.plot(list(np.arange(self.n) + 1), list(table.iloc[1:, 2]))
        plt.title('Annuity')
        plt.xlabel('Periods')
        plt.ylabel('Annuity $')
        plt.subplot(2, 2, 4)
        plt.plot(list(np.arange(self.n) + 1), list(table.iloc[1:, 3]))
        plt.title('Loan Value')
        plt.xlabel('Periods')
        plt.ylabel('Loan Value $')
        plt.show()
        return fig
