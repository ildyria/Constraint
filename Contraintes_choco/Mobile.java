import static choco.Choco.*;
import choco.cp.model.CPModel;
import choco.cp.solver.CPSolver;
import choco.kernel.model.variables.integer.IntegerVariable;

public class Mobile {
	//longueurs
	private int l1, l2, l3, l4;
	//dernieres valeurs trouvees pour les masses
	private int m1, m2, m3;
	//masse maximum disponible
	private int masse_max;

	// variables des contraintes sur les longueurs
	private CPModel myModelL;
	private CPSolver mySolverL;
	//... A completer
	private IntegerVariable iv_l1;
	private IntegerVariable iv_l2;
	private IntegerVariable iv_l3;
	private IntegerVariable iv_l4;
	//...
	private boolean coherent;//vrai si les longueurs sont coherentes

	// variables des contraintes sur les masses
	private CPModel myModelM;
	private CPSolver mySolverM;
	//... A completer
	private IntegerVariable iv_m1;
	private IntegerVariable iv_m2;
	private IntegerVariable iv_m3;
	//...
	private boolean equilibre;

	// constructeur : _lx : longeur de la branche x, m_max : masse maximum disponible
	public Mobile(int _l1, int _l2, int _l3, int _l4, int m_max) {
		// a completer
		iv_l1 = makeIntVar("l1",1,_l1);
		iv_l2 = makeIntVar("l2",1,_l2);
		iv_l3 = makeIntVar("l3",1,_l3);
		iv_l4 = makeIntVar("l4",1,_l4);
		myModelL.addVariable(iv_l1);
		myModelL.addVariable(iv_l2);
		myModelL.addVariable(iv_l3);
		myModelL.addVariable(iv_l4);
		masse_max = m_max;

		iv_m1 = makeIntVar("m1",1,20);
		iv_m2 = makeIntVar("m2",1,20);
		iv_m3 = makeIntVar("m3",1,20);
		myModelM.addVariable(iv_m1);
		myModelM.addVariable(iv_m2);
		myModelM.addVariable(iv_m3);
		//...

		coherent = false;
		equilibre = false;
		poseProblemeLongeur();
		poseProblemeMasse();
	}

	public boolean estEquilibre() {
		return equilibre;
	}

	// accesseurs
	public int getL1() {
		return l1;
	}

	public int getL2() {
		return l2;
	}

	public int getL3() {
		return l3;
	}

	public int getL4() {
		return l4;
	}

	public int getM1() {
		return m1;
	}

	public int getM2() {
		return m2;
	}

	public int getM3() {
		return m3;
	}

	// pose le probleme des longeurs (sans le resoudre),
	// Les longueurs sont coherentes si le mobile est libre
	// (remarque : un peu artificiel car faisable en java 
	// sans contraintes !)
	private void poseProblemeLongeur() {
		//... A completer
		
		// l3 < l2 + l1
		// l4 < l2 + l1
		myModelL.addConstraint(lt(iv_l3,plus(iv_l1,iv_l2)));
		myModelL.addConstraint(lt(iv_l4,plus(iv_l1,iv_l2)));
	}

	// verifie la coherence des longueurs
	public boolean longueursCoherentes() {
		//... A completer
		mySolverL.read(myModelL);
		// solve the problem
		if(mySolverL.solve())
		{
			// return values
			l1 = mySolverL.getVar(iv_l1).getVal();
			l2 = mySolverL.getVar(iv_l2).getVal();
			l3 = mySolverL.getVar(iv_l3).getVal();
			l4 = mySolverL.getVar(iv_l4).getVal();
			return true;
		}
		else
		{
			return false;
		}
	}

	// pose le probleme des masses (sans le resoudre)
	private void poseProblemeMasse() {
		// l3 * M2 = L4 * M3
		// L1 * M1 = L2 * (M2 + M3)
		// M1 != M2 != M3
		// A completer
		myModelM.addConstraint(eq(mult(l3,iv_m2),mult(l4,iv_m3)));
		myModelM.addConstraint(eq(mult(l1,iv_m1),mult(l2,plus(iv_m2,iv_m3))));
		IntegerVariable[] tab = {iv_m1,iv_m2,iv_m3};
		myModelM.addConstraint(allDifferent(tab));
	}

	// resoud le probleme des masses
	// la resolution n'est lancee que si l'encombrement est coherent
	public boolean equilibre() {
		//... A completer
		mySolverM.read(myModelM);
		if(mySolverM.solve())
		{
			// return values
			m1 = mySolverM.getVar(iv_m1).getVal();
			m2 = mySolverM.getVar(iv_m2).getVal();
			m3 = mySolverM.getVar(iv_m3).getVal();
			return true;
		}
		else
		{
			return false;
		}
	}

	// cherche une autre solution pour les masses
	// la recherche d'une autre solution ne doit etre lancee que si le mobile est equilibre
	public boolean autreSolutionMasse() {
		if(estEquilibre())
			return equilibre();
		return false;
	}

	//gestion de l'affichage
	public String toString() {
		String res = "l1 = " + l1 + "\n l2 = " + l2 + "\n l3 = " + l3
				+ "\n l4 = " + l4;
		if (equilibre) {
			res += "\n m1 = " + m1 + "\n m2 = " + m2 + "\n m3 = " + m3;
		} else {
			res += "\n masses pas encore trouvees ou impossibles !";
		}
		return res;
	}

	//tests
	public static void main(String[] args) {
		Mobile m = new Mobile(1, 3, 2, 1, 20);
		//tester avec (1,1,2,3,20),(1,3,1,1,20),(1,3,2,1,20)
		System.out.println(m);
		if (m.longueursCoherentes()) {
			System.out.println("Encombrement OK");
			m.equilibre();
			System.out.println(m);
			while (m.autreSolutionMasse()) {
				System.out.println("OU");
				System.out.println(m);
			}
		} else {
			System.out.println("Encombrement pas coherent !");
		}
	}
}
