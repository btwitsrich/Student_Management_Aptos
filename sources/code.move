module SchoolManagement::School {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a school with funds raised from enrollments.
    struct School has store, key {
        total_funds: u64,  // Total tokens raised through enrollment fees
        enrollment_fee: u64, // Enrollment fee for the school
    }

    /// Function to create a new school with a specified enrollment fee.
    public fun create_school(owner: &signer, fee: u64) {
        let school = School {
            total_funds: 0,
            enrollment_fee: fee,
        };
        move_to(owner, school);
    }

    /// Function for users to enroll in the school by contributing the enrollment fee.
    public fun enroll_in_school(enroller: &signer, school_owner: address) acquires School {
        let school = borrow_global_mut<School>(school_owner);

        // Transfer the enrollment fee from the enroller to the school owner
        let contribution = coin::withdraw<AptosCoin>(enroller, school.enrollment_fee);
        coin::deposit<AptosCoin>(school_owner, contribution);

        // Update the total funds raised
        school.total_funds = school.total_funds + school.enrollment_fee;
    }
}
